class MListNode<E> {
  E _data;
  MListNode<E> _next;

  MListNode(this._data, [this._next]) {
    if (!(_data is E) || (this._next != null && !(this._next?.data is E)))
      throw MListNodeException("Data type invalid.");
  }

  set data(E newData) {
    if (!(newData is E)) throw MListNodeException("Data type invalid.");

    this._data = newData;
  }

  set next(MListNode<E> newNext) {
    if (!(newNext is MListNode<E>))
      throw MListNodeException("Data type invalid.");

    this._next = newNext;
  }

  E get data => this._data;
  MListNode<E> get next => this._next;
}

class MListNodeException {
  String message;
  MListNodeException(this.message);
  @override
  String toString() => message;
}
