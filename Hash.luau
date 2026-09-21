--!strict
--!optimize 2
const Settings = require("./Settings")
const Grid: Settings.PathGrid = {}

-- !!!
const function cb(cellpos: vector, path: Settings.PathfindData): ()
    print("Resolves to default callback for the move function.") 
    path.state = Settings.STATE_VISITED
end

const function decimate(n: number): number
    return n>=0 and n*2 or (-n)*2-1
end

const function hash(p: vector): number
    const x = bit32.bor(decimate(p.x),0b0)
    const y = bit32.bor(decimate(p.y),0b0)
    const z = bit32.bor(decimate(p.z),0b0)
    local r = 0

    for i = 0, 9 do
        const xb = bit32.extract(x,i)
        const yb = bit32.extract(y,i)
        const zb = bit32.extract(z,i)
        const combined = bit32.bor(bit32.lshift(zb,2),bit32.lshift(yb,1),xb)

        r = bit32.bor(r,bit32.lshift(combined, i*3))
    end

    return r
end

const function add(path: Settings.PathfindData): ()
    const b = path.node
    const p = vector.create(b.Position.X,b.Position.Y,b.Position.Z)
    const s = vector.create(b.Size.X,b.Size.Y,b.Size.Z)

    if s.x > Settings.CELL_SIZE.x or s.y > Settings.CELL_SIZE.y or s.z > Settings.CELL_SIZE.z then
        error("node sizes must be smaller than cell sizes.")
    end

    const cx = p.x // Settings.CELL_SIZE.x
    const cy = p.y // Settings.CELL_SIZE.y
    const cz = p.z // Settings.CELL_SIZE.z
    const code = hash(vector.create(cx,cy,cz))

    Grid[code] = path
end

-- !!!
const function remove(p: vector, move: ((cellpos: vector, path: Settings.PathfindData) -> ())?): ()
    const action = move or cb

    const cx = p.x // Settings.CELL_SIZE.x
    const cy = p.y // Settings.CELL_SIZE.y
    const cz = p.z // Settings.CELL_SIZE.z

    const code = hash(vector.create(cx, cy, cz))
    const path = Grid[code]
    

    if path ~= nil and path.state==Settings.STATE_SELECTED then
        const nx = cx * Settings.CELL_SIZE.x
        const ny = cy * Settings.CELL_SIZE.y
        const nz = cz * Settings.CELL_SIZE.z
        action(vector.create(nx,ny,nz),path) 
    end
    Grid[code] = nil
end

const function get(p: vector): (Settings.PathfindData | {})
    const cx = p.x // Settings.CELL_SIZE.x
    const cy = p.y // Settings.CELL_SIZE.y
    const cz = p.z // Settings.CELL_SIZE.z
    const code = hash(vector.create(cx,cy,cz))

    return Grid[code] or {}
end

return {
    hash = hash,
    add = add,
    remove = remove,
    get = get,
}