import 'dart:core';

extension UriChecking on Uri {
  bool isFile() {
    if (scheme == 'file') {
      return true;
    } else {
      return false;
    }
  }
}
