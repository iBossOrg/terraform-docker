init: .git/hooks/pre-commit

pre-commit: .git/hooks/pre-commit
	@set -ex; \
	find . -type f | xargs chmod 644; \
	chmod 755 .git/hooks/*; \
	pre-commit run --all-files

.git/hooks/pre-commit:
	@set -ex; \
	pre-commit install --install-hooks
