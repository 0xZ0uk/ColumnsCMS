//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

library SharedStructs {
  struct Post {
    uint id;
    string title;
    string body;
    bool published;
    address author;
  }

  struct Column {
    uint columnId;
    string name;
    string description;
    Post[] posts;
    address author;
  }
}
