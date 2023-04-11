Function Init {
	
	$secondTimeOut = 60

	$i = 1
	while ($i -eq 1) {
		foreach ($directory in Get-ChildItem -Directory $folderToCheck) {
			Check $directory
		}
				   
		Write-Host "###################################################### $(Get-Date -Format "HH:mm") ######################################################" -fore Yellow
		start-sleep -Seconds $secondTimeOut
	}
}

Function Check {
	Param($directory)
	
	$cleanMessagge = "nothing to commit, working tree clean"
	$notGitRepositoryMessagge = "*not a git repository*"
	cd $directory.PSPath
	git fetch *> $null

	$status = git status 2>&1 $null
	$notGitRepository = $status -like $notGitRepositoryMessagge
	$commit = $status | sls "commits," | Out-String
	$clean = $status | sls $cleanMessagge


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
		
		if ($clean -And $commit -And -not($commit.Contains("nothing"))) {
			git pull
			Write-Host $directory "with" $commit "to pull" -fore Green
			Write-Host $directory "with" $commit "to pull" -fore Green
		}
	}
	else {
		foreach ($subDirectory in Get-ChildItem -Directory) {
			Check $subDirectory
		}
	}
}

if(-Not($args[0])) {
	Write-Host "Folder parameter to pull not found!" -fore Red
	Exit
}

$folderToCheck = $args[0]
Init