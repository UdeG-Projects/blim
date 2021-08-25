abstract class MList<E> {
  int lastIndex;

  MList() : lastIndex = -1;

  /// Get the first element added in list.
  E get first;

  /// Get the last element added in list.
  E get last;

  /// Get the length of the list.
  int get length;

  /// Return true if list is empty.
  bool get isEmpty;

  /// Return true if list is not empty.
  bool get isNotEmpty;

  /// To do something for each element.
  void forEach(void action(E entry));

  /// Method to add an element to List
  void add(E element);

  /// Add elements from other List
  void addAll(MList<E> list);

  /// Remove element at specific index
  E removeAt(int index);

  /// Remove the first element equals to argument
  void remove(E element);

  /// Get List of elements that complains the function
  MList<E> where(bool Function(E) whereFunction);

  /// Remove al items from list.
  void clear();

  /// Convert List to readable String
  String toString();

  /// Read data from index on List Nodes
  E operator [](int index);

  /// Set data from index on List Nodes
  operator []=(int index, E element);

  /// In Dart. Private method can't be overrided. It have to be implemented on
  /// extendend class.
  // bool _isValid(int index);
}

class MListException implements Exception {
  String message;

  MListException(this.message);

  @override
  String toString() => message;

  static MListException RangeError() =>
      MListException("Invalid index. Out of range.");

  static MListException NegativeIndex() =>
      MListException("Invalid index. Can't be negative.");
}
