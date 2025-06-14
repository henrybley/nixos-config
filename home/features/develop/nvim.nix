{inputs, ...}: {
    home.file.".config/nvim/" = {
        source = "${inputs.nvim-config}";
        recursive = true;
    };
}
