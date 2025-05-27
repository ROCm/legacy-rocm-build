import datetime
from collections import defaultdict
import matplotlib.pyplot as plt

author_first_commit = {}
with open("all_commits_authors.txt", "r") as f:
    for line in f:
        parts = line.strip().split()
        if len(parts) < 2:
            continue
        email = parts[0]
        date_str = parts[1]
        
        try:
            commit_date = datetime.datetime.strptime(date_str, "%Y-%m-%d").date()
        except ValueError:
            # Skip lines with malformed dates
            continue

        if email not in author_first_commit or commit_date < author_first_commit[email]:
            author_first_commit[email] = commit_date

new_contributors_by_month = defaultdict(int)
for email, first_commit_date in author_first_commit.items():
    month_key = first_commit_date.strftime("%Y-%m")
    new_contributors_by_month[month_key] += 1

# Sort by month
sorted_months = sorted(new_contributors_by_month.keys())

# Create a list of tuples for plotting
data_for_plot = [(month, new_contributors_by_month[month]) for month in sorted_months]

print("New Contributors by Month:")
for month, count in data_for_plot:
    print(f"{month}: {count}")

# For visualization (similar to daily commits)
months = [datetime.datetime.strptime(m, "%Y-%m") for m, _ in data_for_plot]
counts = [c for _, c in data_for_plot]

plt.figure(figsize=(15, 7))
plt.bar(months, counts, width=20) # Adjust width for monthly bars
plt.xlabel("Month")
plt.ylabel("Number of New Contributors")
plt.title("New Contributors to ROCm/ROCm by Month (Past Two Years)")
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig("new_contributors_by_month.png")
print("New contributors by month histogram saved as new_contributors_by_month.png")
