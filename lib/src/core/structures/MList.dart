import 'package:blim/src/core/abstraction/MList.dart';
import 'package:blim/src/core/structures/MListNode.dart';
import 'package:flutter/material.dart';

class MList<E> {
  MListNode<E> anchor;
  int lastIndex;
  MList() : lastIndex = -1;

  /// Read data from index on List Nodes
  E operator [](int index) {
    MListNode<E> aux = anchor;
    if (index < 0) throw MListException.NegativeIndex();

    for (int i = 0; i < lastIndex - index; i++) {
      if (aux.next == null) throw MListException.RangeError();
      aux = aux.next;
    }
    return aux.data;
  }

  /// Set data from index on List Nodes
  void operator []=(int index, E element) {
    MList<E> _rlist = MList();

    if (index < 0) throw MListException.NegativeIndex();
    if (index > lastIndex) throw MListException.RangeError();

    MListNode tmp = this.anchor;

    for (int i = 0; i <= lastIndex; i++) {
      if (lastIndex - i == index) {
        _rlist.add(element);
        tmp = tmp.next;
        continue;
      }
      _rlist.add(tmp.data);
      tmp = tmp.next;
    }

    this.clear();
    this.addAll(_rlist);
  }

  /// Method to add an element to List
  void add(element) {
    if (anchor == null)
      anchor = MListNode<E>(element);
    else {
      anchor = MListNode<E>(element, anchor);
    }

    lastIndex++;
  }

  /// Add elements from other List
  void addAll(MList<E> list) {
    list?.forEach((element) {
      this.add(element);
    });
  }

  /// Remove the first element equals to argument
  void remove(E element) {
    MList<E> _rlist = MList();
    bool removed = false;

    MListNode<E> tmp = anchor;

    for (int i = 0; i <= lastIndex; i++) {
      if (!removed && tmp?.data == element)
        removed = true;
      else
        _rlist.add(tmp.data);
      tmp = tmp.next;
    }

    this.clear();
    this.addAll(_rlist);
  }

  /// Remove element at specific index
  E removeAt(int index) {
    MList<E> _rlist = MList();

    if (index < 0) throw MListException.RangeError();
    if (index > lastIndex) throw MListException.RangeError();

    MListNode tmp = anchor;
    E tmpData;

    for (int i = 0; i <= lastIndex; i++) {
      if (lastIndex - i == index)
        tmpData = tmp.data;
      else
        _rlist.add(tmp.data);
      tmp = tmp.next;
    }
    this.clear();
    this.addAll(_rlist);
    return tmpData;
  }

  /// Get List of elements that complains the function
  MList<E> where(bool Function(E) whereFunction) {
    MList<E> _list = MList();
    MListNode<E> tmpAnchor = this.anchor;

    while (tmpAnchor?.data != null) {
      if (whereFunction(tmpAnchor.data)) _list.add(tmpAnchor.data);
      tmpAnchor = tmpAnchor.next;
    }

    return _list;
  }

  /// Get index of element that complains the function
  int indexWhere(bool Function(E) whereFunction) {
    MListNode<E> tmpAnchor = this.anchor;
    int index = 0;
    while (tmpAnchor?.data != null) {
      if (whereFunction(tmpAnchor.data)) return index;
      tmpAnchor = tmpAnchor.next;
      index++;
    }

    return null;
  }

  /// Remove al items from list.
  void clear() {
    anchor = null;
    lastIndex = -1;
  }

  /// Get the first element added in list.
  get first => anchor.data;

  /// Get the last element added in list.
  get last => this[lastIndex];

  /// Return true if list is empty.
  bool get isEmpty => anchor == null;

  /// Return true if list is not empty.
  bool get isNotEmpty => anchor != null;

  /// Get the length of the list.
  int get length => lastIndex + 1;

  /// Convert List to readable String
  String toString() {
    String toString = "[";
    MListNode<E> aux = anchor;
    while (aux?.data != null) {
      toString += "${aux.data}";
      toString += aux?.next == null ? "]" : ", ";
      aux = aux.next;
    }

    return toString;
  }

  List<Widget> toWidgets(Widget Function(E) func) {
    List<Widget> widgets = [];

    MListNode tmp = anchor;

    for (int i = 0; i <= lastIndex; i++) {
      widgets.add(func(tmp.data));
      tmp = tmp.next;
    }
    return widgets;
  }

  /// To do something for each element.
  void forEach(void action(E entry)) {
    if (isEmpty) return;

    MListNode<E> aux = anchor;
    while (aux?.data != null) {
      action(aux.data);
      aux = aux.next;
    }
  }
}
