defmodule Fibril.Helpers do
  alias Fibril.Repo

  @doc """
    A simple preload function to load associated attributes after an
    INSERT or UPDATE as there is no way to do a preload as part of these
    functions.
  """
  def preload({:ok, entity}, nil) do
    {:ok, entity}
  end

  def preload({:ok, entity}, preloads) do
    {:ok, Repo.preload(entity, preloads, force: true)}
  end

  def preload({:error, error}, _preloads) do
    {:error, error}
  end

  @doc """
  Runs the given function inside a transaction.

  This function is a wrapper around `Ecto.Repo.transaction`, with the following differences:

  - It accepts only a lambda of arity 0 or 1 (i.e. it doesn't work with multi).
  - If the lambda returns `:ok | {:ok, result}` the transaction is committed.
  - If the lambda returns `:error | {:error, reason}` the transaction is rolled back.
  - If the lambda returns any other kind of result, an exception is raised, and the transaction is rolled back.
  - The result of `transact` is the value returned by the lambda.

  This function accepts the same options as `Ecto.Repo.transaction/2`.
  """
  @spec transact((-> result) | (module -> result), Keyword.t()) :: result
        when result: :ok | {:ok, any} | :error | {:error, any}
  def transact(fun, opts \\ []) do
    transaction_result =
      Repo.transaction(
        fn repo ->
          lambda_result =
            case Function.info(fun, :arity) do
              {:arity, 0} -> fun.()
              {:arity, 1} -> fun.(repo)
            end

          case lambda_result do
            :ok -> {__MODULE__, :transact, :ok}
            :error -> Repo.rollback({__MODULE__, :transact, :error})
            {:ok, result} -> result
            {:error, reason} -> Repo.rollback(reason)
          end
        end,
        opts
      )

    with {outcome, {__MODULE__, :transact, outcome}}
         when outcome in [:ok, :error] <- transaction_result,
         do: outcome
  end
end
