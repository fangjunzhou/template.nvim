local template = require("template")

describe("add", function()
  it("adds positive numbers", function()
    assert.are.equal(5, template.add(2, 3))
  end)

  it("adds negative numbers", function()
    assert.are.equal(-5, template.add(-2, -3))
  end)

  it("adds numbers with different signs", function()
    assert.are.equal(-1, template.add(2, -3))
  end)

  it("adds zero", function()
    assert.are.equal(4, template.add(4, 0))
    assert.are.equal(4, template.add(0, 4))
    assert.are.equal(0, template.add(0, 0))
  end)

  it("adds fractional numbers", function()
    assert.are.equal(3.75, template.add(1.25, 2.5))
  end)
end)
