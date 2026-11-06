/-!
# Задачи на быструю сортировку — Lean 4

Запуск всех задач:          `lean --run QuickSort.lean`
Запуск одной задачи (1–4):  `lean --run QuickSort.lean 3`

Сортировка `quickSort` написана вручную и работает «на месте»: Lean меняет
массив без копирования, пока на него есть только одна ссылка. То, что
рекурсия всегда завершается, проверяет сам компилятор: функции несут
доказательства, что границы подотрезка сужаются (`termination_by`).
Ещё доказано, что после сортировки длина массива не меняется (`quickSort_size`).
В задаче 4 используется стандартная библиотечная `Array.qsort`.

Версия Lean: 4.28.
-/

/-! ## Быстрая сортировка -/

/-- Цикл разбиения Ломуто для отрезка `a[lo..hi]` с опорным элементом `pivot`
(он лежит в `a[hi]`). Всё, что меньше опорного, сдвигается в начало отрезка.
Возвращает новый массив и итоговую позицию опорного элемента `p`
вместе с доказательством, что `lo ≤ p ≤ hi`. -/
def partitionLoop {α : Type} [Inhabited α] (lt : α → α → Bool) (pivot : α)
    (lo hi : Nat) (a : Array α) (i j : Nat)
    (h₁ : lo ≤ i) (h₂ : i ≤ j) (h₃ : j ≤ hi) :
    Array α × { p : Nat // lo ≤ p ∧ p ≤ hi } :=
  if hj : j < hi then
    if lt a[j]! pivot then
      partitionLoop lt pivot lo hi (a.swapIfInBounds i j) (i + 1) (j + 1)
        (by omega) (by omega) (by omega)
    else
      partitionLoop lt pivot lo hi a i (j + 1) h₁ (by omega) (by omega)
  else
    -- ставим опорный элемент на его окончательное место
    (a.swapIfInBounds i hi, ⟨i, h₁, by omega⟩)
termination_by hi - j

/-- Разбиение отрезка `a[lo..hi]`. Опорным берём средний элемент:
так сортировка не вырождается в квадратичную на уже упорядоченных данных. -/
def partition {α : Type} [Inhabited α] (lt : α → α → Bool) (a : Array α)
    (lo hi : Nat) (h : lo ≤ hi) : Array α × { p : Nat // lo ≤ p ∧ p ≤ hi } :=
  let a := a.swapIfInBounds ((lo + hi) / 2) hi
  partitionLoop lt a[hi]! lo hi a lo lo (Nat.le_refl lo) (Nat.le_refl lo) h

/-- Быстрая сортировка отрезка `a[lo..hi]`: разбить, затем рекурсивно
отсортировать левую и правую части. -/
def quickSortRange {α : Type} [Inhabited α] (lt : α → α → Bool)
    (a : Array α) (lo hi : Nat) : Array α :=
  if h : lo < hi then
    let (a, ⟨p, _, _⟩) := partition lt a lo hi (Nat.le_of_lt h)
    let a := quickSortRange lt a lo (p - 1)
    quickSortRange lt a (p + 1) hi
  else
    a
termination_by hi - lo

/-- Быстрая сортировка всего массива; `lt` — отношение «меньше». -/
def quickSort {α : Type} [Inhabited α] (lt : α → α → Bool) (a : Array α) : Array α :=
  quickSortRange lt a 0 (a.size - 1)

/-! ### Доказательство: сортировка не теряет и не добавляет элементов
Lean проверяет эти теоремы при компиляции, как и обычный код. -/

theorem partitionLoop_size {α : Type} [Inhabited α] (lt : α → α → Bool) (pivot : α)
    (lo hi : Nat) (a : Array α) (i j : Nat) (h₁ : lo ≤ i) (h₂ : i ≤ j) (h₃ : j ≤ hi) :
    (partitionLoop lt pivot lo hi a i j h₁ h₂ h₃).1.size = a.size := by
  fun_induction partitionLoop lt pivot lo hi a i j h₁ h₂ h₃ <;> simp_all

theorem quickSortRange_size {α : Type} [Inhabited α] (lt : α → α → Bool)
    (a : Array α) (lo hi : Nat) : (quickSortRange lt a lo hi).size = a.size := by
  fun_induction quickSortRange lt a lo hi
  case case1 =>
    have hs := congrArg (fun r => r.1.size) ‹partitionLoop _ _ _ _ _ _ _ _ _ _ = _›
    simp only [partitionLoop_size, Array.size_swapIfInBounds] at hs
    simp_all (config := { zetaDelta := true })
  case case2 => simp_all

/-- Длина массива после `quickSort` не меняется. -/
theorem quickSort_size {α : Type} [Inhabited α] (lt : α → α → Bool) (a : Array α) :
    (quickSort lt a).size = a.size :=
  quickSortRange_size lt a 0 (a.size - 1)

-- Проверки, которые выполняются прямо при компиляции файла.
#guard quickSort (· < ·) (#[] : Array Int) == #[]
#guard quickSort (· < ·) #[5] == #[5]
#guard quickSort (· < ·) #[3, 1, 2] == #[1, 2, 3]
#guard quickSort (· < ·) #[5, -1, 5, 0, 3, -1, 8, 0] == #[-1, -1, 0, 0, 3, 5, 5, 8]
#guard quickSort (· < ·) #[1, 2, 3, 4, 5, 6] == #[1, 2, 3, 4, 5, 6]
#guard quickSort (· > ·) #[1, 2, 3, 4, 5, 6] == #[6, 5, 4, 3, 2, 1]

/-! ## Вспомогательные функции -/

/-- `n` случайных целых чисел из отрезка `[lo, hi]`. -/
def randomInts (n : Nat) (lo hi : Int) : IO (Array Int) :=
  (Array.range n).mapM fun _ => do
    let r ← IO.rand 0 (hi - lo).toNat
    return lo + r

/-- Упорядочен ли массив по неубыванию. -/
def isSorted (a : Array Int) : Bool :=
  (a.toList.zip a.toList.tail).all fun (x, y) => x ≤ y

/-- Дополнить строку пробелами слева до ширины `w`. -/
def padLeft (w : Nat) (s : String) : String :=
  "".pushn ' ' (w - s.length) ++ s

/-- Напечатать числа строками по `perRow` штук, каждое шириной `w`. -/
def printRows (a : Array Int) (perRow w : Nat) : IO Unit := do
  let mut line := ""
  let mut k := 0
  for x in a do
    line := line ++ padLeft w (toString x)
    k := k + 1
    if k % perRow == 0 then
      IO.println line
      line := ""
  unless line.isEmpty do
    IO.println line

def printMatrix (m : Array (Array Int)) : IO Unit :=
  m.forM fun row => IO.println (String.join (row.toList.map (padLeft 4 ∘ toString)))

/-! ## Задача 1
Задана последовательность из 1000 целых чисел. Переставить элементы так,
чтобы они располагались в порядке возрастания. -/

def task1 : IO Unit := do
  IO.println "Задача 1. 1000 случайных целых чисел из [-10000, 10000] по возрастанию:"
  let a ← randomInts 1000 (-10000) 10000
  let sorted := quickSort (· < ·) a
  printRows sorted 20 7
  IO.println s!"Проверка: элементов {sorted.size}, упорядочены — {if isSorted sorted then "да" else "нет"}"

/-! ## Задача 2
Одномерный массив случайных целых чисел из интервала [50, 100]
отсортировать по возрастанию быстрой сортировкой. -/

def task2 : IO Unit := do
  IO.println "Задача 2. Массив случайных чисел из [50, 100]"
  let a ← randomInts 20 50 100
  IO.print "до:    "; printRows a 20 4
  IO.print "после: "; printRows (quickSort (· < ·) a) 20 4

/-! ## Задача 3
Двумерный массив случайных чисел из интервала [5, 61]: отсортировать по
возрастанию его первый столбец быстрой сортировкой. Остальные столбцы
остаются на месте. -/

/-- Отсортировать столбец `0` матрицы `m`. -/
def sortFirstColumn (m : Array (Array Int)) : Array (Array Int) :=
  let col := quickSort (· < ·) (m.map (·[0]!))
  m.mapIdx fun i row => row.set! 0 col[i]!

def task3 : IO Unit := do
  IO.println "Задача 3. Матрица 6×5 из чисел [5, 61], сортируем первый столбец"
  let m ← (Array.range 6).mapM fun _ => randomInts 5 5 61
  IO.println "до:"; printMatrix m
  IO.println "после:"; printMatrix (sortFirstColumn m)

/-! ## Задача 4
Отсортировать список студентов группы по алфавиту стандартной `qsort`.

Строки в Lean сравниваются по кодам символов Юникода. Для кириллицы это
почти алфавит, но буква «Ё» имеет код меньше «А», и «Ёлкин» оказался бы
первым. Поэтому сравниваем по ключам: регистр не важен, «ё» стоит сразу
после «е». -/

/-- Ключ буквы для сравнения по русскому алфавиту. -/
def letterKey (c : Char) : Nat :=
  let c :=
    if 'А' ≤ c ∧ c ≤ 'Я' then Char.ofNat (c.toNat + 32)   -- А..Я → а..я
    else if c = 'Ё' then 'ё'
    else c.toLower                                          -- латиница
  if c = 'ё' then 2 * 'е'.toNat + 1 else 2 * c.toNat

/-- Лексикографическое «меньше» для списков ключей. -/
def lexLess : List Nat → List Nat → Bool
  | [], _ :: _ => true
  | _, [] => false
  | x :: xs, y :: ys => x < y || (x == y && lexLess xs ys)

/-- «Строка `a` идёт раньше `b` по алфавиту». -/
def alphaLt (a b : String) : Bool :=
  lexLess (a.toList.map letterKey) (b.toList.map letterKey)

#guard alphaLt "Егоров" "Ёлкин" && alphaLt "Ёлкин" "Жуков"
#guard alphaLt "Петров" "Петрова" && !alphaLt "Петрова" "Петров"

def students : Array String := #[
  "Сидорова Анна", "Иванов Иван", "Ёлкин Артём", "Петрова Ольга",
  "Абрамова Мария", "Егоров Дмитрий", "Жуков Алексей", "Петров Сергей",
  "Яковлев Никита", "Кузнецов Илья", "Белова Дарья", "Иванова Екатерина"]

def task4 : IO Unit := do
  IO.println "Задача 4. Список группы по алфавиту (стандартная Array.qsort):"
  let sorted := students.qsort alphaLt
  sorted.size.forM fun i _ => IO.println s!"{padLeft 3 (toString (i + 1))}. {sorted[i]!}"

/-! ## Запуск -/

def main (args : List String) : IO Unit := do
  IO.setRandSeed (← IO.monoNanosNow)   -- новые случайные числа при каждом запуске
  match args with
  | []    => do task1; IO.println ""; task2; IO.println ""; task3; IO.println ""; task4
  | ["1"] => task1
  | ["2"] => task2
  | ["3"] => task3
  | ["4"] => task4
  | _     => IO.eprintln "Укажите номер задачи от 1 до 4 (или ничего, чтобы запустить все)"
