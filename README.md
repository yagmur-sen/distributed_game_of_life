# DistributedGameOfLife

# TODO – Core Concurrent Game of Life (Cell = Process)

**Shared contracts (please follow these so everything fits together):**

- Coordinates: tuples `{x, y}` (non‑negative integers).
- Cell state: atoms `:alive` and `:dead`.
- Cell module: `GameOfLife.Cell`
  - `start_link(opts)`
  - `set_neighbors(pid, neighbor_pids)`
  - `tick(pid)`
  - `get_state(pid) :: :alive | :dead`
- Board module: `GameOfLife.Board`
  - `start_link(opts)`
  - `cell_at(board_pid, {x, y}) :: pid | nil`
  - `step(board_pid)`

Implementation details inside each module are completely free.

---

### T1 – Cell process basic behavior

- [ ] Create module `GameOfLife.Cell`.
- [ ] Implement `start_link/1` to start a cell process.
- [ ] Implement `get_state/1` to return the current state (`:alive` or `:dead`).

*(Internal representation / GenServer vs `spawn` is up to the implementer.)*

---

### T2 – Cell neighbor management

- [ ] In `GameOfLife.Cell`, implement `set_neighbors(pid, neighbor_pids)`.
- [ ] Store neighbor PIDs internally in any way you like.

*(How you store neighbors and when you call this is up to you, as long as the function exists.)*

---

### T3 – Cell tick logic (Game of Life rules)

- [ ] In `GameOfLife.Cell`, implement `tick(pid)`.
- [ ] On `tick/1`, the cell should:
  - determine neighbor states (using any message/exchange pattern),
  - apply standard Game of Life rules (B3/S23),
  - update its own state.

*(Exact messaging pattern and timing are up to the implementer.)*

---

### T4 – Board process: spawn and track cells

- [ ] Create module `GameOfLife.Board`.
- [ ] Implement `start_link/1` to start a board process.
- [ ] On init, create a grid of `GameOfLife.Cell` processes.
- [ ] Implement `cell_at(board_pid, {x, y})` to return the pid for a given coordinate (or `nil` if none).

*(Grid size, options, and internal data structure are up to the implementer.)*

---

### T5 – Board neighbor wiring

- [ ] In `GameOfLife.Board`, after all cells are spawned:
  - for each `{x, y}`, compute its neighbor coordinates,
  - find their PIDs via `cell_at/2`,
  - call `GameOfLife.Cell.set_neighbors(cell_pid, neighbor_pids)`.

*(Edge behavior – wrap-around vs fixed borders – is up to the implementer.)*

---

### T6 – Board step function

- [ ] In `GameOfLife.Board`, implement `step(board_pid)`.
- [ ] `step/1` should cause **all cells** to advance one generation:
  - e.g., by calling `GameOfLife.Cell.tick/1` on each cell.

*(You decide whether ticks are synchronous/async and how you ensure they move in lockstep.)*