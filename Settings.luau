export type PathfindData = { node: BasePart, dir: vector, state: number }
export type PathGrid = { [number]: PathfindData }

-- sp and ep are start position and end position, n is cells
export type Cell = buffer -- { b: BasePart, d: vector }
export type Flowfield = buffer

return {
    CELL_SIZE = vector.create(6,6,6),

    STATE_NOT_VISITED = 0b1,
    STATE_VISITED = 0b10,
    STATE_SELECTED = 0b100,
    STATE_TERMINATED = 0b1000,
}