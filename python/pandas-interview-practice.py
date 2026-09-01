"""Pandas patterns from statistics/Python interview preparation."""

import pandas as pd


def revenue_by_segment(df: pd.DataFrame) -> pd.DataFrame:
    """Return total revenue by segment, highest revenue first."""
    return (
        df.groupby("segment", as_index=False)["revenue"]
        .sum()
        .sort_values("revenue", ascending=False)
    )


def conversion_by_variant(df: pd.DataFrame) -> pd.DataFrame:
    """Calculate experiment conversion rate by variant."""
    return (
        df.groupby("variant", as_index=False)
        .agg(
            users=("user_id", "nunique"),
            conversions=("converted", "sum"),
        )
        .assign(conversion_rate=lambda x: x["conversions"] / x["users"])
    )


def validate_merge(left: pd.DataFrame, right: pd.DataFrame) -> pd.DataFrame:
    """Example merge with simple row-count validation."""
    before = len(left)
    merged = left.merge(right, on="customer_id", how="left", validate="many_to_one")
    after = len(merged)

    if before != after:
        raise ValueError("Merge changed the left-table row count.")

    return merged


# Interview debugging checklist:
# - Confirm data types.
# - Inspect nulls.
# - Define the intended grain.
# - Validate row counts after merges.
# - Confirm aggregation logic.
# - Inspect a sample of the output before interpreting results.
