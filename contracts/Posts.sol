pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Posts {
  address public owner;

  using Counters for Counters.Counter;
  Counters.Counter private _postIds;

  struct Post {
    uint postId;
    string title;
    string body;
    bool published;
    address author;
  }

  /// Events
  event PostCreated(uint id, string title, string hash);
  event PostUpdated(uint id, string title, string hash, bool published);


  constructor() {
    console.log("Deploying post to Column address");
    owner = msg.sender;
  }

  /// 1. Create post
  function createPost(string memory title, string memory hash) public {
    /// 1.1 require author to own 1 column
  }


  /// 2. Update post

  /// 3. Fetch post by hash

  /// 4. Fetch all posts from a Column

  /// 5. Tip post (optional)
}