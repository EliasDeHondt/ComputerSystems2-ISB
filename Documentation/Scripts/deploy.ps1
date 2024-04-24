############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 24/04/2024        #
############################

param (
    [string]$action = "-deploy"
)

if ($action -eq "-deploy") {
    gcloud compute instances create win-docker-server-new --project=cs2-isb-elias-de-hondt --image=win-docker-server --zone=us-central1-c --metadata windows-startup-script-cmd="docker run -d -p 80:80 eliasdh/iis-site-windows:v1.0"
} elseif ($action -eq "-delete") {
    gcloud compute instances delete win-docker-server-new --zone=us-central1-c --quiet
} else {
    Write-Host "Invalid option"
}