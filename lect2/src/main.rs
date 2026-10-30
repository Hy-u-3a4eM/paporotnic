fn selection_sort<T: Ord>(array: &mut [T]) {
    for i in 0..array.len() - 1 {
        let mut m = i;
        for j in (i + 1)..array.len() {
            if array[j] < array[m] {
                m = j;
            }
        }

        array.swap(m, i);
    }
}

fn main() {
    let mut numbers = [5, 2, 1, 3, 4];
    selection_sort(&mut numbers);
    println!("{:?}", numbers);
}
