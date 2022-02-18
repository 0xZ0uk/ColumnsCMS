const { expect } = require("chai");
const Columns = artifacts.require("Columns");
const uuidv4 = require("uuid").v4;

describe("Columns", function (accounts) {
  it("Should return a new Column", async function () {
    const columns = await Columns.new();
    await columns.createColumn("theDesk", "the first column to ever exist");

    const myColumns = await columns.fetchAllColumns();

    assert.equal(myColumns[0].name, "theDesk");
  });

  it("Should update existing Column name", async function () {
    const columns = await Columns.new();
    await columns.createColumn("theDesk", "the first column to ever exist");

    let myColumns = await columns.fetchAllColumns();

    await columns.updateColumnName("theDESK", myColumns[0].columnId);

    myColumns = await columns.fetchAllColumns();

    assert.equal(myColumns[0].name, "theDESK");
  });
});
