### Base function
function Write-Color ($output, $color) {
  Write-Host "$output" -ForegroundColor $color
}

### Helper extensions
function Write-Cyan ($output) {
  Write-Color $output Cyan
}

function Write-DarkCyan ($output) {
  Write-Color $output DarkCyan
}


function Write-Magenta ($output) {
  Write-Color $output Magenta
}

function Write-Green ($output) {
  Write-Color $output Green
}

function Write-Red ($output) {
  Write-Color $output Red
}

function Write-Yellow ($output) {
  Write-Color $output Yellow
}

function Write-DarkYellow ($output) {
  Write-Color $output DarkYellow
}

function Write-White ($output) {
  Write-Color $output White
}

### Functional extensions
function Write-White ($output) {
  Write-White $output
}
