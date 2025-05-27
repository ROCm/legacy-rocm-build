import datetime
from collections import defaultdict
import csv

# --- Get daily commit counts and aggregate to monthly commits ---
monthly_total_commits = defaultdict(int)
with open("daily_commits_count.txt", "r") as f:
    for line in f:
        parts = line.strip().split()
        if len(parts) < 2:
            continue
        date_str = parts[0]
        count = int(parts[1])
        
        try:
            commit_date = datetime.datetime.strptime(date_str, "%Y-%m-%d").date()
            month_key = commit_date.strftime("%Y-%m")
            monthly_total_commits[month_key] += count
        except ValueError:
            continue

# --- Get new contributors by month ---
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
            continue

        if email not in author_first_commit or commit_date < author_first_commit[email]:
            author_first_commit[email] = commit_date

new_contributors_by_month = defaultdict(int)
for email, first_commit_date in author_first_commit.items():
    month_key = first_commit_date.strftime("%Y-%m")
    new_contributors_by_month[month_key] += 1

# --- Combine data and write to CSV ---
all_months = sorted(list(set(monthly_total_commits.keys()) | set(new_contributors_by_month.keys())))

csv_file_path = "ROCm_commit_contributor_data.csv"
with open(csv_file_path, "w", newline="") as csvfile:
    fieldnames = ["Month", "New Contributors", "Total Commits"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for month in all_months:
        writer.writerow({
            "Month": month,
            "New Contributors": new_contributors_by_month.get(month, 0),
            "Total Commits": monthly_total_commits.get(month, 0)
        })

print(f"Data successfully written to {csv_file_path}")
