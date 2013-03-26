function thesisfigs

%% Plot of spectral densities (stitched/unstitched) of white and pink noise
if true
   % ----- White noise -----
   dt = 1;
   yw = randn(2^18,1);
   
   figure
   subplot(1,2,1)
   colors = lines(4);
   for i = 1:4
      [fw{i}, Sw{i}] = fftSD(dt,yw,'avgs',2^(2*i-2));
      loglog(fw{i},Sw{i},'Color',colors(i,:))
      hold on
   end
   % Add stitched spectrum:
   [fws, Sws] = fftSD(dt,yw,'autostitch','minAvgs',3);
   loglog(fws,Sws,'k','Linewidth',1)
   
   % Add dots to lowest frequency point:
   for i = 1:4
      loglog(fw{i}(2),Sw{i}(2),'.','Color',colors(i,:),'MarkerSize',10)
   end
   
   title('White noise')
   xlabel('Normalized frequency')
   ylabel('Spectral density')
%    legend({'N_{avg} = 1','N_{avg} = 4','N_{avg} = 16','N_{avg} = 64',...
%       'stitched'})
   
   % ----- 1/f noise -----
   yf = f_alpha(2^18,1,1); % Generate the 1/f noise
   
   subplot(1,2,2)
   colors = lines(4);
   for i = 1:4
      [ff{i}, Sf{i}] = fftSD(dt,yf,'avgs',2^(2*i-2));
      loglog(ff{i},Sf{i},'Color',colors(i,:))
      hold on
   end
   % Add stitched spectrum:
   [ffs, Sfs] = fftSD(dt,yf,'autostitch','minAvgs',3);
   loglog(ffs,Sfs,'k','Linewidth',1)
   
   % Add dots to lowest frequency point:
   for i = 1:4
      loglog(ff{i}(2),Sf{i}(2),'.','Color',colors(i,:),'MarkerSize',10)
   end

   set(gca,'YTick',10.^(-5:2:5))
   ylim([1e-6,1e6])
   
   title('1/f noise')
   xlabel('Normalized frequency')
   ylabel('Spectral density')
   legend({'N_{avg} = 1','N_{avg} = 4','N_{avg} = 16','N_{avg} = 64',...
      'stitched'},'FontSize',10)
   
   % ----- Size figure -----
   tightenSubplot(gcf,'lPad',0.5,'rPad',1.25,'tPad',0.3,'bPad',0.4,...
      'figw',6.5,'figh',2.5,'gapx',0.5,'stripaxlab',false)
   
   figure
   for i=1:4
      subplot(4,1,i)
      [~, xb] = hist(Sw{i}(2:end),100);
      hist(Sw{i}(2:end),100);
%       h = findobj(gca,'Type','patch');
%       set(h,'LineStyle','none')
      if i==1
         hold on
         plot(xb,mean(diff(xb))*length(Sw{i})*chi2pdf(xb/dt,2)/dt,'r', ...
            'Linewidth',1)
      elseif i==4
         hold on
         plot(xb,mean(diff(xb))*length(Sw{i}) * ...
            normpdf(xb,2*dt,2*dt/sqrt(64)),'r','Linewidth',1)
      end
      set(gca,'ytick',[])
   end
   tightenSubplot(gcf,'lPad',0.5,'rPad',0.25,'tPad',0.3,'bPad',0.4,...
      'figw',6.5,'figh',6)
   xlim([0,4])
   set(gca,'XTick',0:4)
   xlabel('Spectral density (unitless)')
end

end