[xml]$Global:xmlWPF = '<Window x:Class="System.Windows.Window"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Title="MainWindow" Height="450" Width="800">
    <Grid>
        <Button x:Name="backButton" Content="Back" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" Width="50"/>
        <Button x:Name="fwdButton" Content="Forward" HorizontalAlignment="Left" Margin="65,10,0,0" VerticalAlignment="Top" Width="50"/>
        <TextBox x:Name="addressBar" Margin="175,10,0,0" TextWrapping="Wrap" Text="http://www.google.com" VerticalAlignment="Top"/>
        <Button x:Name="goButton" Content="Go!" HorizontalAlignment="Left" Margin="120,10,0,0" VerticalAlignment="Top" Width="50"/>
        <WebBrowser x:Name="webBrowserForm" Margin="0,35,0,0"/>

    </Grid>
</Window>'

try{ Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,system.windows.forms
} catch {
Throw "Failed to load WPF."}

$Global:xamGUI = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xmlWPF))
$xmlWPF.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | %{Set-Variable -Name ($_.Name) -Value $xamGUI.FindName($_.Name) -Scope Global}

$goButton = $xamGUI.FindName("goButton")
$fwdButton = $xamGUI.FindName("fwdButton")
$backButton = $xamGUI.FindName("backButton")
$addressBar = $xamGUI.FindName("addressBar")
$webBrowserForm = $xamGUI.FindName("webBrowserForm")

$goButton.add_click({$webBrowserForm.Navigate($addressBar.Text)})
$fwdButton.add_click({$webBrowserForm.GoForward()})
$backButton.add_click({$webBrowserForm.GoBack()})

$xamGUI.ShowDialog() | Out-Null