import esbuild from 'esbuild';
import path from 'path';
import rails from 'esbuild-rails';

esbuild.build({
  entryPoints: ["application.js"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  plugins: [rails()],
}).catch(() => process.exit(1));
