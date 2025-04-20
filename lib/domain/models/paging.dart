class Paging<T> {
  final List<T> data;
  final bool hasNext;

  const Paging({this.data = const [], this.hasNext = true});

  Paging<T> next(List<T> data, {bool refresh = false}) {
    return Paging<T>(data: refresh ? data : [...this.data, ...data], hasNext: data.isNotEmpty);
  }

  int offset(bool refresh) => refresh ? 0 : data.length;

  Paging<T> replaceWith<K>(T item, K Function(T e) key) {
    final newData = data.toList();
    final index = newData.indexWhere((element) => key(element) == key(item));
    if (index != -1) {
      newData[index] = item;
    }
    return Paging<T>(data: newData, hasNext: hasNext);
  }
}
