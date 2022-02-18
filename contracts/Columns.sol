//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Posts.sol";

contract Columns {
    address public owner;

    using Counters for Counters.Counter;
    using Posts for Posts.Post;
    Counters.Counter private _columnIds;

    /// Column = blog
    struct Column {
        uint columnId;
        string name;
        string description;
        Post[] posts;
        address author;
    }

    /// Mappings
    mapping(address => Column[]) private ownerColumns;
    mapping(uint => Column) private idToColumn;
    mapping(string => Column) private hashToColumn;
    mapping(uint => Post) private idToPost;
    mapping(string => Post) private hashPost;

    /// Events
    event ColumnCreated(uint columnId, string name, string hash);
    event ColumnUpdated(uint columnId, string name, string hash);
    

    constructor() {
        console.log("Deploying Columns");
        owner = msg.sender;
    }

    /// Creates a Column
    function createColumn(string memory name, string memory hash, string memory description) public onlyOneColumn() {
        _columnIds.increment();
        uint columnId = _columnIds.current();
        Column storage column = idToColumn[columnId];
        column.columnId = columnId;
        column.name = name;
        column.description = description;
        hashToColumn[hash] = column;
        emit ColumnCreated(columnId, name, hash);
    }

    /// Transfer Column ownership
    function transferColumnOwnership(address newOwner, uint columnId) public onlyColumnOwner(columnId) {
        Column storage toTransfer = idToColumn[columnId];
        toTransfer.author = newOwner;
    }

    /// Updates Column name
    function updateColumnName(string memory name, uint columnId) public onlyColumnOwner(columnId) {
        Column storage toUpdate = idToColumn[columnId];
        toUpdate.name = name;
    }

    /// Fetch Column
    function fetchColumn(uint columnId) public view returns (Column memory) {
        return idToColumn[columnId];
    }

    /// Fetch All Columns
    function fetchAllColumns() public view returns (Column[] memory) {
        uint itemCount = _columnIds.current();
        uint currentIndex = 0;

        Column[] memory columns = new Column[](itemCount);
        for (uint i = 0; i < itemCount; i++) {
            uint currentId = i + 1;
            Column storage currentItem = idToColumn[currentId];
            columns[currentIndex] = currentItem;
            currentIndex += 1;
        }

        return columns;
    }

    /// Modifiers
    /// onlyColumnOwner - allows only column owner to invoke function
    modifier onlyColumnOwner(uint columnId) {
        Column storage column = idToColumn[columnId];
        require(msg.sender == column.author);
        _;
    }

    modifier onlyOneColumn() {
        require(ownerColumns[msg.sender].length == 0);
        _;
    }
}
