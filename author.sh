#/bin/sh
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
            for f in */__openerp__.py __unported__/*/__openerp__.py
            do
                if [[ -e $f ]]
                then
                    sed -i -f ~/work/OCA/author.sed $f
                    git add $f
                fi
            done
            #git diff --cached
            git commit -F ~/work/OCA/commit_message
            git push origin
        else
            echo ${reponame}: no branch ${version}
        fi
    done
    popd
done

