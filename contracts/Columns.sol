//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./SharedStructs.sol";

contract Columns {
    address public owner;

    using Counters for Counters.Counter;
    Counters.Counter private _columnIds;

    SharedStructs.Column[] public columns;

    /// Mappings
    mapping(address => SharedStructs.Column[]) public ownerColumns;
    mapping(uint => SharedStructs.Column) private idToColumn;
    mapping(string => SharedStructs.Column) private hashToColumn;

    /// Events
    event ColumnCreated(uint columnId, string name, string hash);
    event ColumnUpdated(uint columnId, string name, string hash);

    constructor() {
        console.log("Deploying Columns");
        owner = msg.sender;
    }

    /// Creates a Column
    function createColumn(string memory name, string memory hash) public hasNoColumns() {
        _columnIds.increment();
        uint columnId = _columnIds.current();
        SharedStructs.Column storage column = idToColumn[columnId];
        column.columnId = columnId;
        column.name = name;
        column.description = hash;
        column.author = msg.sender;
        idToColumn[columnId] = column;
        hashToColumn[hash] = column;
        columns.push(column);
        emit ColumnCreated(columnId, name, hash);
    }

    /// Transfer Column ownership
    function transferColumnOwnership(address newOwner, uint columnId) public onlyColumnOwner(columnId) {
        SharedStructs.Column storage toTransfer = idToColumn[columnId];
        toTransfer.author = newOwner;
    }

    /// Updates Column name
    function updateColumnName(string memory name, uint columnId) public onlyColumnOwner(columnId) {
        SharedStructs.Column storage toUpdate = idToColumn[columnId];
        toUpdate.name = name;
    }

    /// Fetch Column
    function fetchColumn(uint columnId) public view returns (SharedStructs.Column memory) {
        return idToColumn[columnId];
    }

    /// Fetch All Columns
    function fetchAllColumns() public view returns (SharedStructs.Column[] memory) {
        uint itemCount = _columnIds.current();
        uint currentIndex = 0;

        SharedStructs.Column[] memory tmpColumns = new SharedStructs.Column[](itemCount);
        for (uint i = 0; i < itemCount; i++) {
            uint currentId = i + 1;
            SharedStructs.Column storage currentItem = idToColumn[currentId];
            tmpColumns[currentIndex] = currentItem;
            currentIndex += 1;
        }

        return columns;
    }

    /// Modifiers
    /// onlyColumnOwner - allows only column owner to invoke function
    modifier onlyColumnOwner(uint columnId) {
        SharedStructs.Column storage column = idToColumn[columnId];
        require(msg.sender == column.author);
        _;
    }

    // User has no owned Columns
    modifier hasNoColumns() {
        require(ownerColumns[msg.sender].length == 0);
        _;
    }

    // User can only own 1 column
    modifier ownsColumn() {
        require(ownerColumns[msg.sender].length == 1);
        _;
    }
}
