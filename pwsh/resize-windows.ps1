<#
  Restores and positions matching application windows to the saved layout below.
  Application Windows are matched by process name; every matching window is positioned.
#>

$DesiredWindowDimensions = [ordered]@{
  'Google Chrome'                = [pscustomobject]@{ Top = 15; Left =  81; Width = 2402; Height = 1366 }
  'Neovide'                      = [pscustomobject]@{ Top = 15; Left =  81; Width = 2402; Height = 1366 }
  'Alacritty'                    = [pscustomobject]@{ Top = 15; Left =  81; Width = 2402; Height = 1366 }
  'Alacritty-v1'                 = [pscustomobject]@{ Top = 43; Left = 144; Width = 2274; Height = 1320 }
  'Alacritty-v2'                 = [pscustomobject]@{ Top = 43; Left = 144; Width = 2274; Height = 1320 }
  'Alacritty-v3'                 = [pscustomobject]@{ Top = 43; Left = 144; Width = 2274; Height = 1320 }
  'Brave Browser'                = [pscustomobject]@{ Top = 43; Left = 144; Width = 2274; Height = 1320 }
  'Microsoft Visual Studio'      = [pscustomobject]@{ Top = 43; Left = 144; Width = 2274; Height = 1320 }
  'Sublime Text'                 = [pscustomobject]@{ Top = 92; Left = 231; Width = 2091; Height = 1242 }
  'Windows Terminal'             = [pscustomobject]@{ Top = 92; Left = 231; Width = 2091; Height = 1242 }
}

if ($null -eq ('WindowDimensionsV8' -as [type])) {
  Add-Type @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

public static class WindowDimensionsV8 {
  private const int DWMWA_EXTENDED_FRAME_BOUNDS = 9;
  private const int SW_RESTORE = 9;
  private const uint SWP_NOZORDER = 0x0004;
  private const uint SWP_NOACTIVATE = 0x0010;

  private delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

  [DllImport("user32.dll")]
  private static extern bool EnumWindows(EnumWindowsProc callback, IntPtr lParam);

  [DllImport("user32.dll")]
  private static extern bool IsWindowVisible(IntPtr hWnd);

  [DllImport("user32.dll")]
  private static extern bool IsIconic(IntPtr hWnd);

  [DllImport("user32.dll")]
  private static extern bool IsZoomed(IntPtr hWnd);

  [DllImport("user32.dll")]
  private static extern bool ShowWindow(IntPtr hWnd, int command);

  [DllImport("user32.dll", SetLastError = true)]
  private static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int x, int y,int width, int height, uint flags);

  [DllImport("user32.dll")]
  private static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);

  [DllImport("user32.dll")]
  private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

  [DllImport("user32.dll", CharSet = CharSet.Unicode)]
  private static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int maxCount);

  [DllImport("dwmapi.dll")]
  private static extern int DwmGetWindowAttribute(IntPtr hWnd, int attribute, out RECT value, int size);

  [StructLayout(LayoutKind.Sequential)]
  private struct RECT {
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
  }

  public sealed class WindowInfo {
    public IntPtr Handle { get; set; }
    public uint ProcessId { get; set; }
    public string Title { get; set; }
    public int Top { get; set; }
    public int Left { get; set; }
    public int Width { get; set; }
    public int Height { get; set; }
  }

  public sealed class VisibleBounds {
    public int Top { get; set; }
    public int Left { get; set; }
    public int Width { get; set; }
    public int Height { get; set; }
  }

  public static WindowInfo[] GetVisibleWindows() {
    var windows = new List<WindowInfo>();

    EnumWindows(delegate(IntPtr hWnd, IntPtr lParam) {
      if (!IsWindowVisible(hWnd)) {
        return true;
      }

      var titleBuilder = new StringBuilder(1024);
      GetWindowText(hWnd, titleBuilder, titleBuilder.Capacity);
      var title = titleBuilder.ToString();
      if (String.IsNullOrWhiteSpace(title)) {
        return true;
      }

      uint processId;
      GetWindowThreadProcessId(hWnd, out processId);

      RECT bounds;
      if (DwmGetWindowAttribute(
        hWnd,
        DWMWA_EXTENDED_FRAME_BOUNDS,
        out bounds,
        Marshal.SizeOf(typeof(RECT))) != 0) {
        return true;
      }

      windows.Add(new WindowInfo {
        Handle = hWnd,
        ProcessId = processId,
        Title = title,
        Left = bounds.Left,
        Top = bounds.Top,
        Width = bounds.Right - bounds.Left,
        Height = bounds.Bottom - bounds.Top
      });
      return true;
    }, IntPtr.Zero);

    return windows.ToArray();
  }

  public static void SetVisibleBounds(
    IntPtr hWnd, int left, int top, int width, int height) {
    if (IsIconic(hWnd) || IsZoomed(hWnd)) {
      ShowWindow(hWnd, SW_RESTORE);
      System.Threading.Thread.Sleep(100);
    }

    RECT windowRect;
    RECT extendedFrameBounds;
    if (!GetWindowRect(hWnd, out windowRect) ||
      DwmGetWindowAttribute(hWnd, DWMWA_EXTENDED_FRAME_BOUNDS, out extendedFrameBounds,Marshal.SizeOf(typeof(RECT))) != 0) {
      throw new InvalidOperationException("Could not read the window frame bounds.");
    }

    int leftInset = extendedFrameBounds.Left - windowRect.Left;
    int topInset = extendedFrameBounds.Top - windowRect.Top;
    int rightInset = windowRect.Right - extendedFrameBounds.Right;
    int bottomInset = windowRect.Bottom - extendedFrameBounds.Bottom;

    if (!SetWindowPos(hWnd, IntPtr.Zero, left - leftInset, top - topInset, width + leftInset + rightInset, height + topInset + bottomInset,SWP_NOZORDER | SWP_NOACTIVATE)) {
      throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error(),"Could not position the window.");
    }

  }

  public static VisibleBounds GetVisibleBounds(IntPtr hWnd) {
    RECT bounds;
    if (DwmGetWindowAttribute(hWnd, DWMWA_EXTENDED_FRAME_BOUNDS, out bounds,Marshal.SizeOf(typeof(RECT))) != 0) {
      throw new InvalidOperationException("Could not read the window frame bounds.");
    }

    return new VisibleBounds {
      Top = bounds.Top,
      Left = bounds.Left,
      Width = bounds.Right - bounds.Left,
      Height = bounds.Bottom - bounds.Top
    };
  }
}
"@
}

$targets = @(
  [pscustomobject]@{ Application = 'Google Chrome'; ProcessNames = @('chrome') }
  [pscustomobject]@{ Application = 'Neovide'; ProcessNames = @('neovide') }
  [pscustomobject]@{ Application = 'Alacritty'; ProcessNames = @('alacritty') }
  [pscustomobject]@{ Application = 'Alacritty-v1'; ProcessNames = @('alacritty-v1') }
  [pscustomobject]@{ Application = 'Alacritty-v2'; ProcessNames = @('alacritty-v2') }
  [pscustomobject]@{ Application = 'Alacritty-v3'; ProcessNames = @('alacritty-v3') }
  [pscustomobject]@{ Application = 'Brave Browser'; ProcessNames = @('brave') }
  [pscustomobject]@{ Application = 'Microsoft Visual Studio'; ProcessNames = @('devenv') }
  [pscustomobject]@{ Application = 'Sublime Text'; ProcessNames = @('sublime_text') }
  [pscustomobject]@{ Application = 'Windows Terminal'; ProcessNames = @('WindowsTerminal') }
)

$processNamesById = @{}
Get-Process | ForEach-Object {
  $processNamesById[[uint32]$_.Id] = $_.ProcessName
}

$windows = [WindowDimensionsV8]::GetVisibleWindows()
$results = foreach ($target in $targets) {
  $matches = $windows | Where-Object {
    $target.ProcessNames -contains $processNamesById[$_.ProcessId]
  }

  if ($null -eq $matches) {
    [pscustomobject]@{
      Application = $target.Application
      Status      = 'Not found'
      ProcessId   = $null
      Title       = $null
      Left        = $null
      Top         = $null
      Width       = $null
      Height      = $null
    }
    continue
  }

  foreach ($window in $matches) {
    $desired = $DesiredWindowDimensions[$target.Application]
    try {
      [WindowDimensionsV8]::SetVisibleBounds(
        $window.Handle,
        $desired.Left,
        $desired.Top,
        $desired.Width,
        $desired.Height
      )
      $actual = [WindowDimensionsV8]::GetVisibleBounds($window.Handle)
      $status = 'Positioned'
    }
    catch {
      $actual = $window
      $status = "Failed: $($_.Exception.Message)"
    }

    [pscustomobject]@{
      Application = $target.Application
      Status      = $status
      ProcessId   = $window.ProcessId
      Title       = $window.Title
      Left        = $actual.Left
      Top         = $actual.Top
      Width       = $actual.Width
      Height      = $actual.Height
    }
  }
}

$results | Format-Table -AutoSize
