import matplotlib.pyplot as plt
import datetime

dates = []
counts = []

with open("daily_commits_count.txt", "r") as f:
    for line in f:
        parts = line.strip().split()
        dates.append(datetime.datetime.strptime(parts[0], "%Y-%m-%d").date())
        counts.append(int(parts[1]))

plt.figure(figsize=(15, 7))
plt.bar(dates, counts, width=0.8)
plt.xlabel("Date")
plt.ylabel("Number of Commits")
plt.title("Daily Commits to ROCm/ROCm (Past Two Years)")
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig("daily_commits_histogram.png")
print("Daily commits histogram saved as daily_commits_histogram.png")
