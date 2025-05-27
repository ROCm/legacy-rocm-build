from collections import defaultdict

daily_counts = defaultdict(int)

with open("commits.txt", "r") as f:
    for line in f:
        date = line.strip()
        daily_counts[date] += 1

sorted_dates = sorted(daily_counts.keys())

with open("daily_commits_count.txt", "w") as f:
    for date in sorted_dates:
        f.write(f"{date} {daily_counts[date]}\n")
