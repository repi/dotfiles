#!/usr/bin/env nu
# latest.commit.nu

# originally from https://gist.github.com/ddupas/05a4b85bb9d6d5181d84620ebc91088f

# get latest commit of a repo without cloning the repo
# motivation:
# not satisfied with the speed of all the suggestions here:
# https://stackoverflow.com/questions/1209999/how-to-use-git-to-get-just-the-latest-revision-of-a-project

export def main [...repo] {
	if	( $repo | is-empty ) {
		'usage: ./latest.commit.nu nushell/nu_scripts' 
			| print
	} else {
		let githuburl =  $'https://github.com/($repo.0)/commits'
        http get $githuburl        
               | lines
               | where {$in =~  $"($repo.0)/commit/.*?\""}
               | first 1
               | $in.0
               | from xml
               | $in.attributes.href
               | path split
               | last
	}
}
