$folderToCheck = "C:\Projects"
$secondTimeOut = 60

$i = 1
while ($i -eq 1) {
	foreach ($file in Get-ChildItem $folderToCheck) {
		$cleanMessagge = "nothing to commit, working tree clean"
		$notGitRepositoryMessagge = "*not a git repository*"
		cd $file.PSPath
		git fetch *> $null

		$status = git status 2>&1 $null
		$notGitRepository = $status -like $notGitRepositoryMessagge
		$commit = $status | sls "commits," | Out-String
		$clean = $status | sls $cleanMessagge
		$add = $status | sls "add"
		$unstage = $status | sls "unstaged"
		$push = $status | sls "push"
		$stage = $status | sls "Changes to be committed"

		if(-Not $notGitRepository) {
			if ($commit) {
				$commit = $commit.ToString().Substring($commit.IndexOf("by") + 3)
				$commit = $commit.Substring(0, $commit.IndexOf("commits") + 7)
			}
			else {
				$commit = git status | sls "commit," | Out-String

				if ($commit) {
					$commit = $commit.ToString().Substring($commit.IndexOf("by") + 3)
					$commit = $commit.Substring(0, $commit.IndexOf("commit") + 6)
				}
			}

			if ($clean) {
				if ($commit -And -not($commit.Contains("nothing"))) {
					Write-Host $file "with" $commit "to pull" -fore Green
				}
				else {
					if ($push) {
							Write-Host $file -fore Red
					}
				}
			}
			else {
				if ($commit) {
					if ($add -Or $unstage -Or $stage) {
						Write-Host $file "with" $commit "to pull" -fore Magenta
					}
					else {
						if ($push) {
							Write-Host $file "with" $commit "to pull" -fore Red
						}
						else {
							Write-Host $file "with" $commit "to pull" -fore Green
						}
					}
				}
				else {
					if ($add -Or $unstage -Or $stage) {
						Write-Host $file -fore Magenta
					}
					else {
						if ($push) {
							Write-Host $file -fore Red
						}
					}
				}
			}
		}
	}
			   
	Write-Host "###################################################### $(Get-Date -Format "HH:mm") ######################################################" -fore Yellow
	start-sleep -Seconds $secondTimeOut
}