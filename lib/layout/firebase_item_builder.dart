// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart' show DataSnapshot, DatabaseEvent, Query;
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';

import 'package:flutter/widgets.dart';

typedef FirebaseAnimatedListItemBuilder = Widget Function(
  BuildContext context,
  DataSnapshot snapshot,
);

/// An AnimatedList widget that is bound to a query
class FirebaseItemBuilder extends StatefulWidget {
  /// Creates a container that automatically updates its child.
  const FirebaseItemBuilder({
    super.key,
    required this.query,
    required this.elementIndex,
    required this.itemBuilder,
    this.defaultChild,
  });

  /// The index of the element to be displayed
  final int elementIndex;

  /// A Firebase query to use to populate the animated list
  final Query query;

  /// A widget to display while the query is loading. Defaults to an empty
  /// Container().
  final Widget? defaultChild;

  /// Called, as needed, to build list item widgets.
  ///
  /// List items are only built when they're scrolled into view.
  ///
  /// The [DataSnapshot] parameter indicates the snapshot that should be used
  /// to build the item.
  ///
  /// Implementations of this callback should assume that [AnimatedList.removeItem]
  /// removes an item immediately.
  final FirebaseAnimatedListItemBuilder itemBuilder;

  @override
  FirebaseItemBuilderState createState() => FirebaseItemBuilderState(index: elementIndex);
}

class FirebaseItemBuilderState extends State<FirebaseItemBuilder> {
  FirebaseItemBuilderState({
    required this.index,
  });

  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();
  late List<DataSnapshot> _model;
  bool _loaded = false;
  final int index;

  @override
  void didChangeDependencies() {
    /// There is one snapshot for each child of the query.
    _model = FirebaseList(
      query: widget.query,
      onChildAdded: _onChildAdded,
      onChildRemoved: _onChildRemoved,
      onChildChanged: _onChildChanged,
      onChildMoved: _onChildMoved,
      onValue: _onValue,
    );

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Cancel the Firebase stream subscriptions
    _model.clear();

    super.dispose();
  }

  void _onChildAdded(int index, DataSnapshot snapshot) {
    if (!_loaded) {
      return; // AnimatedList is not created yet
    }
    _animatedListKey.currentState?.insertItem(index);
  }

  void _onChildRemoved(int index, DataSnapshot snapshot) {
    // The child should have already been removed from the model by now
    assert(index >= _model.length || _model[index].key != snapshot.key);
    _animatedListKey.currentState?.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return widget.itemBuilder(context, snapshot);
      },
    );
  }

  // No animation, just update contents
  void _onChildChanged(int index, DataSnapshot snapshot) {
    setState(() {});
  }

  // No animation, just update contents
  void _onChildMoved(int fromIndex, int toIndex, DataSnapshot snapshot) {
    setState(() {});
  }

  void _onValue(DataSnapshot _) {
    setState(() {
      _loaded = true;
    });
  }

  Widget _buildItem(BuildContext context) {
    return widget.itemBuilder(context, _model[index]);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return widget.defaultChild ?? const Text('');
    }
    return _buildItem.call(context);
  }
}

typedef ChildCallback = void Function(int index, DataSnapshot snapshot);
typedef ChildMovedCallback = void Function(
  int fromIndex,
  int toIndex,
  DataSnapshot snapshot,
);
typedef ValueCallback = void Function(DataSnapshot snapshot);
typedef ErrorCallback = void Function(FirebaseException error);

/// Sorts the results of `query` on the client side using `DataSnapshot.key`.
class FirebaseList extends ListBase<DataSnapshot>
    with
        // ignore: prefer_mixin
        StreamSubscriberMixin<DatabaseEvent> {
  FirebaseList({
    required this.query,
    this.onChildAdded,
    this.onChildRemoved,
    this.onChildChanged,
    this.onChildMoved,
    this.onValue,
    this.onError,
  }) {
    if (onChildAdded != null) {
      listen(query.onChildAdded, _onChildAdded, onError: _onError);
    }
    if (onChildRemoved != null) {
      listen(query.onChildRemoved, _onChildRemoved, onError: _onError);
    }
    if (onChildChanged != null) {
      listen(query.onChildChanged, _onChildChanged, onError: _onError);
    }
    if (onChildMoved != null) {
      listen(query.onChildMoved, _onChildMoved, onError: _onError);
    }
    if (onValue != null) {
      listen(query.onValue, _onValue, onError: _onError);
    }
  }

  /// Database query used to populate the list
  final Query query;

  /// Called when the child has been added
  final ChildCallback? onChildAdded;

  /// Called when the child has been removed
  final ChildCallback? onChildRemoved;

  /// Called when the child has changed
  final ChildCallback? onChildChanged;

  /// Called when the child has moved
  final ChildMovedCallback? onChildMoved;

  /// Called when the data of the list has finished loading
  final ValueCallback? onValue;

  /// Called when an error is reported (e.g. permission denied)
  final ErrorCallback? onError;

  // ListBase implementation
  final List<DataSnapshot> _snapshots = <DataSnapshot>[];

  @override
  int get length => _snapshots.length;

  @override
  set length(int value) {
    throw UnsupportedError('List cannot be modified.');
  }

  @override
  DataSnapshot operator [](int index) => _snapshots[index];

  @override
  void operator []=(int index, DataSnapshot value) {
    throw UnsupportedError('List cannot be modified.');
  }

  @override
  void clear() {
    cancelSubscriptions();

    // Do not call super.clear(), it will set the length, it's unsupported.
  }

  int _indexForKey(String key) {
    for (int index = 0; index < _snapshots.length; index++) {
      if (key == _snapshots[index].key) {
        return index;
      }
    }

    throw FallThroughError();
  }

  void _onChildAdded(DatabaseEvent event) {
    int index = 0;
    if (event.previousChildKey != null) {
      index = _indexForKey(event.previousChildKey!) + 1;
    }
    _snapshots.insert(index, event.snapshot);
    onChildAdded!(index, event.snapshot);
  }

  void _onChildRemoved(DatabaseEvent event) {
    final index = _indexForKey(event.snapshot.key!);
    _snapshots.removeAt(index);
    onChildRemoved!(index, event.snapshot);
  }

  void _onChildChanged(DatabaseEvent event) {
    final index = _indexForKey(event.snapshot.key!);
    _snapshots[index] = event.snapshot;
    onChildChanged!(index, event.snapshot);
  }

  void _onChildMoved(DatabaseEvent event) {
    final fromIndex = _indexForKey(event.snapshot.key!);
    _snapshots.removeAt(fromIndex);

    int toIndex = 0;
    if (event.previousChildKey != null) {
      final prevIndex = _indexForKey(event.previousChildKey!);
      toIndex = prevIndex + 1;
    }
    _snapshots.insert(toIndex, event.snapshot);
    onChildMoved!(fromIndex, toIndex, event.snapshot);
  }

  void _onValue(DatabaseEvent event) {
    onValue!(event.snapshot);
  }

  void _onError(Object o) {
    onError?.call(o as FirebaseException);
  }
}
