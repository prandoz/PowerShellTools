$folderToCheck = "C:\Projects"
$secondTimeOut = 60

$i = 1
while ($i -eq 1) {
	foreach ($file in Get-ChildItem $folderToCheck) {
		$cleanMessagge = "nothing to commit, working tree clean"
		cd $file.PSPath
		git fetch *> $null

		$commit = git status | sls "commits," | Out-String

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

		if (git status | sls $cleanMessagge) {
			if ($commit -And -not($commit.Contains("nothing"))) {
				Write-Host $file "with" $commit "to pull" -fore Green
			}
		}
		else {
			$add = git status | sls "add"
			$unstage = git status | sls "unstaged"
			$push = git status | sls "push"
			$stage = git status | sls "Changes to be committed"

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
			   
	Write-Host "###################################################### $(Get-Date -Format "HH:mm") ######################################################" -fore Yellow
	start-sleep -Seconds $secondTimeOut
}