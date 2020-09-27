default:
	@echo "Choose one build version (app_dev|app_prod)"

app_dev:
	shards build -Dpreview_mt app

app_prod:
	shards build -Dpreview_mt --release --no-debug app
