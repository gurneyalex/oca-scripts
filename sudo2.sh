#/bin/bash
for repo in */
do
    pushd $repo
    reponame=$(basename $repo)
    echo $reponame
    git fetch origin
    for version in 6.1 7.0 8.0
    do
        if [[ ${reponame} == l10n-brazil && ${version} == 7.0 ]]
        then
           echo "skip ${reponame} ${version}"
        else
            git reset --hard HEAD
            git branch -D ${version}
            if git checkout -q -B ${version} origin/${version}
            then
                if [[ -e .travis.yml ]] && ! $(grep -q sudo .travis.yml)
                then
                    sed -i -f ~/work/oca-scripts/sudo2.sed .travis.yml
                    git add .travis.yml
                else
                    if [[ -e .travis.yml ]]
                    then
                        echo "unexpected sudo in ${reponame} ${version}"
                        echo "unexpected sudo in ${reponame} ${version}" >> /tmp/sudo2.log
                        grep sudo .travis.yml >>/tmp/sudo2.log
                    fi
                fi
                git diff --cached
                git commit -q -F ~/work/oca-scripts/commit_message_sudo2
                git push origin
                #git reset -q --hard HEAD~
            else
                echo "${reponame}: no branch ${version}"
            fi
        fi
    done
    popd
done

