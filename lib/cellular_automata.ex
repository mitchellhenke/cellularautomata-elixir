defmodule CellularAutomata do
  use GenServer

  def make_list(0), do: []
  def make_list(n) do
    pid = make_one({nil, nil})
    make_list([pid], n)
  end

  def make_list(list, 0) do
    [left_end | [second_left | _rest]] = list

    CellularAutomata.set_ln(second_left, left_end)
    list
  end

  def make_list([rn | _rest] = list, n) do
    pid = make_one({nil, rn})
    CellularAutomata.set_ln(rn, pid)
    make_list([pid | list], n - 1)
  end

  def make_one({ln, rn}) do
    status = round(:random.uniform)
    {:ok, pid} = CellularAutomata.start_link({status, ln, rn})

    pid
  end

  def start_link(state = {_status, _left_neighbor, _right_neighbor}) do
    GenServer.start_link(__MODULE__, state)
  end

  def set_state(pid, state = {_status, _left_neighbor, _right_neighbor}) do
    GenServer.call(pid, {:set_state, state})
  end

  def set_status(pid, new_status) do
    GenServer.call(pid, {:set_status, new_status})
  end

  def set_ln(pid, ln) do
    GenServer.call(pid, {:set_ln, ln})
  end

  def set_rn(pid, rn) do
    GenServer.call(pid, {:set_rn, rn})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def get_status(pid) do
    GenServer.call(pid, :get_status)
  end

  def evolve(pid) do
    GenServer.call(pid, :evolve)
  end

  def handle_call({:set_state, state = {_status, _ln, _rn}} , _from, _state) do
    {:reply, state, state}
  end

  def handle_call({:set_status, new_status} , _from, state) do
    {_old_status, ln, rn} = state
    new_state = {new_status, ln, rn}
    {:reply, new_status, new_state}
  end

  def handle_call({:set_ln, new_ln} , _from, state) do
    {status, _ln, rn} = state
    new_state = {status, new_ln, rn}
    {:reply, new_ln, new_state}
  end

  def handle_call({:set_rn, new_rn} , _from, state) do
    {status, ln, _rn} = state
    new_state = {status, ln, new_rn}
    {:reply, new_rn, new_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:get_status, _from, state) do
    {status, _, _} = state
    {:reply, status, state}
  end

  def handle_call(:evolve, _from, state = {status, ln, rn}) do
    new_status = do_evolve(state)
    {:reply, new_status, {status, ln, rn}}
  end

  def do_evolve({status, ln, nil}) do
    CellularAutomata.get_status(ln)
    |> next_status(status)
  end

  def do_evolve({status, nil, rn}) do
    CellularAutomata.get_status(rn)
    |> next_status(status)
  end

  def do_evolve({status, ln, rn}) do
    ln_status = CellularAutomata.get_status(ln)
    rn_status = CellularAutomata.get_status(rn)

    next_status(ln_status + rn_status, status)
  end

  defp next_status(0, 0) do
    0
  end

  defp next_status(1, 0) do
    0
  end

  defp next_status(2, 0) do
    1
  end

  defp next_status(0, 1) do
    0
  end

  defp next_status(1, 1) do
    1
  end

  defp next_status(2, 1) do
    0
  end
end
