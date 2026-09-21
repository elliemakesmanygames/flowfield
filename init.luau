--!strict
--!optimize 2
const Settings = require("./Flowfield/Settings")
const Hash = require("./Flowfield/Hash")

-- only one node can be in one cell, and other pathfinding nodes must be in neighboring cells.
-- the limitations are as of now 1024 cells per axis.
const function node(p: vector)
    const node = Instance.new("Part")
    node.Anchored = true
    node.Position = Vector3.new(p.x,p.y,p.z)
    node.Size = Vector3.one
    node.Shape = Enum.PartType.Ball
    node.Parent = workspace
    return node
end

-- the compute function will begin by only mapping out non-complex polygons (rectangles and squares).
-- later, vertice types will be added and this will be expanded upon.
-- A* with heuristic
const function compute(s: vector, e: vector, n: number)
    const snode, enode = node(s), node(e)
    local curr = snode

    for i = 1, n+1 do
        --curr = node() is the last line
    end

    Hash.add({ node=enode, dir=vector.zero, state=Settings.STATE_NOT_VISITED })
end
