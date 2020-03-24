function plotImageROI(axes, roi)
% Plot Cropped ROI Image
%
% Authors:  David S. White
% Contact: dwhite7@wisc.edu

% Updates:
% --------
% 2019-12       OR      Wrote the code
% 2019-02-20    DSW     Comments and name change to plotMetric
% 2019-04-09    DSW     Added plotting best value in red. Updated to new
%                       disc_fit strucure;

cla(axes);
set(axes, 'Visible','off');
% draw only if analysis is completed
if isfield(roi, 'image')
    if isfield(roi.image,'cropped')
        imshow(roi.image.cropped,[],'Parent',axes);
    end
end

end