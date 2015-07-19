for f in */*/__openerp__.py ; do
    python -c 'import sys; d=open(sys.argv[1]).read(); print eval(d).get("external_dependencies")' $f
done
