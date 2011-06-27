awk '{printf("%s", $1); for (i=2; i<=NF; i++) printf " & %0.2f",$i; printf "\n"}'
