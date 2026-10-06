$files = "01_staging", "02_schema", "03_transform", "04_validate", "05_reports"

foreach ($f in $files) {
    Write-Host "`n=== $f ===" -ForegroundColor Cyan
    docker exec pipeline_pg psql -U postgres -d customer_pipeline -v ON_ERROR_STOP=1 -f "/project/sql/$f.sql"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "STOPPED: $f failed. Fix the first error above." -ForegroundColor Red
        exit 1
    }
}
Write-Host "`nPipeline finished." -ForegroundColor Green