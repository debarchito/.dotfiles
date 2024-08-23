import Pkg, REPL, OhMyREPL as OMR;

atreplinit() do repl
  if !isdefined(repl, :interface)
    repl.interface = REPL.setup_interface(repl);
  end
  REPL.numbered_prompt!(repl);

  if isfile("Project.toml") || isfile("Manifest.toml")
    try
      @async @eval using Revise;
    catch e
      @warn e
    end
    Pkg.activate(".");
  end

  OMR.colorscheme!("OneDark");
  OMR.enable_autocomplete_brackets(true);
  OMR.Passes.RainbowBrackets.activate_256colors();
  # "fzf" must be available in path
  OMR.enable_fzf(true);
end
