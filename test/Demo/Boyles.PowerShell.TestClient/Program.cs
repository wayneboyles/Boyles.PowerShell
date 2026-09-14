using Boyles.PowerShell.Diagnostics;
using Boyles.PowerShell.TestClient.Components;
using Boyles.PowerShell.TestClient.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// DiagnosticsStore is both the IHttpDiagnosticsSink every HuduClient is wired to and the
// in-memory log the Diagnostics panel reads from - scoped so each browser tab (circuit)
// gets its own connection and call history.
builder.Services.AddScoped<DiagnosticsStore>();
builder.Services.AddScoped<IHttpDiagnosticsSink>(sp => sp.GetRequiredService<DiagnosticsStore>());
builder.Services.AddScoped<HuduConnectionService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
