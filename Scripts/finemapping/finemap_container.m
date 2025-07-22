function runFinemapFromFiles(a_mat_path, glmt_mat_path)
%rng(32193213, 'twister')
  D1 = load(a_mat_path);
  D2 = load(glmt_mat_path);
  A = D1.a;
  glmt = D2.glmt;
  M = size(A,1);
  assert(isequal(size(A),[M M]), 'A must be square');
  assert(numel(glmt)==M, 'glmt length mismatch');
  theta = FinemapMiXeRv0(A,glmt);
  probs = theta(2*M+1:end);
  effect_size = theta(1:M);
  variance = theta(M+1:2*M);
  save('resultsFinemapMixer.mat','probs','effect_size','variance');
  fprintf('✅ resultsFinemapMixer.mat saved\n');
end









