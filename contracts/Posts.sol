//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./SharedStructs.sol";
import "./Columns.sol";

contract Posts is Columns {
  using Counters for Counters.Counter;
  Counters.Counter private _postIds;

  /// Events
  event PostCreated(uint id, string title, string hash);
  event PostUpdated(uint id, string title, string hash, bool published);

  /// Mappings
  // mapping(uint => SharedStructs.Post) private idToPost;
  // mapping(string => SharedStructs.Post) private hashToPost;

  constructor() {
    console.log("Deploying post to Column address");
    owner = msg.sender;
  }

  /// 1. Create post
  function createPost(string memory title, string memory hash) public ownsColumn() {
    _postIds.increment();
    uint postId = _postIds.current();
    SharedStructs.Post memory post;
    post.title = title;
    post.body = hash;
    post.author = msg.sender;
    // Adds the created post to the msg.sender Column
    ownerColumns[msg.sender][0].posts.push(post);
    emit PostCreated(postId, title, hash);
  }


  /// 2. Update post
  function updatePost(uint postId, string memory title, string memory hash, bool published) public ownsColumn() {
    SharedStructs.Post[] storage posts = ownerColumns[msg.sender][0].posts;

    for (uint i = 0; i < posts.length; i++) {
      if (posts[i].id == postId) {
        posts[i].title = title;
        posts[i].published = published;
        posts[i].body = hash;
        emit PostUpdated(postId, title, hash, published);
      }
    }
  }

  /// 3. Fetch post by Id
  function fetchPost(uint postId) public view returns (SharedStructs.Post memory) {
    SharedStructs.Post[] storage posts = ownerColumns[msg.sender][0].posts;
    for (uint i = 0; i < posts.length; i++) {
      if (posts[i].id == postId) {
        return posts[i];
      }
    }

    return posts[0];
  }

  /// 4. Tip post (optional)
}