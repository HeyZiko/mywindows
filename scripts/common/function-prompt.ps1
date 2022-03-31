function prompt
{
  # Pause for input
  Write-Host -NoNewLine 'Press any key to continue...';
  # Exclude control keys to allow CTRL+C to cancel
  Do {$choice = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')} 
  until ( $choice.ControlKeyState -eq 0 ) 
  # Use the following if we want to exclude more than just the control keys (eg. F keys) 
  #until ( $choice.VirtualKeyCode -notin @( 16..19) + @(112..190) ); 
  Write-White
}
