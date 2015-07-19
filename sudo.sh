#/bin/bash
for repo in */
do
    pushd $repo
    reponame=$(basename $repo)
    echo $reponame
    git fetch origin
    for version in 6.1 7.0 8.0
    do
        git reset --hard HEAD
        git branch -D ${version}
        if git checkout -q -B ${version} origin/${version}
        then
            if [[ -e .travis.yml ]]
            then
               sed -i -f ~/work/OCA/sudo.sed .travis.yml
               git add .travis.yml
            fi
            git diff --cached
            git commit -F ~/work/OCA/commit_message_sudo
            git push origin
            #git reset --hard HEAD~
        else
            echo ${reponame}: no branch ${version}
        fi
    done
    popd
done

