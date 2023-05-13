TBD

Install optional test dependencies in user mode::

  pip3 install -e ".[test]"

Run unit tests::

  python3 -m unittest discover -s tests -t .

Run coverage (test dependencies are needed)::

  coverage run --omit=tests/* -m unittest discover -s tests -t .

Report on coverage::

  coverage report
