% function skinMask = skinDetection(RGB, YCrCb)
% 
%     R = RGB(:,:,1);
%     G = RGB(:,:,2);
%     B = RGB(:,:,3);
% 
%     Y = YCrCb(:,:,1);
%     Cb = YCrCb(:,:,2);
%     Cr = YCrCb(:,:,3);
% 
%     %fprintf('Cr: min=%d, max=%d\n', min(Cr(:)), max(Cr(:)));
%     %fprintf('Cb: min=%d, max=%d\n', min(Cb(:)), max(Cb(:)));
% 
%     diffForR = (max(R(:)) - min(R(:)));
%     diffForG = (max(G(:)) - min(G(:)));
%     diffForB = (max(B(:)) - min(B(:)));
% 
% % 90<Y<180, 90<Cr<130, 80<Cb<150 from "An Efficient Face Detection in Color Images Using
% %Eye Mouth Triangular Approach"
%     skinMask = (R > 100) & (G > 50) & (B > 50) & (R > G) & (R > B) & ...
%             (95 < Cb) & (Cb < 172) & (Y < 180) & ...
%             (abs(R - G) > 15) & (diffForR > 135) & (diffForG > 135) & (diffForB > 135) & ...
%             (100 < Cr) & (Cr < 150) & (Cb > 80) & ...
%             (Cr <= (1.5862 * Cb + 20)) & (Cr >= (0.3448 * Cb + 76.2069)) & ...
%             (Cr <= (-1.15 * Cb + 301.75));
%     % Check if there are any ones (1 = skin) in the skinMask
%     if any(skinMask(:))
%         disp('At least one pixel classified as skin (white) in the skin mask.');
%     else
%         disp('No pixels classified as skin in the skin mask.');
%     end
% 
%     % Creates a structuring element. https://www.mathworks.com/help/images/structuring-elements.html
%     % disk = the shape, 3 = radius of 3 pixels
%     %se = strel('disk', 7);  
%     %skinMask = imdilate(skinMask, se);
%     skinMask = imfill(skinMask, 'holes'); % fill holes
% 
% end

function skinMask = skinDetection(image_corr)

    YCrCb = ConvertRGB2YCrCb(image_corr); 

    R = image_corr(:,:,1);
    G = image_corr(:,:,2);
    B = image_corr(:,:,3);

    Y = YCrCb(:,:,1);
    Cb = YCrCb(:,:,2);
    Cr = YCrCb(:,:,3);
    
    diffForR = (max(R(:)) - min(R(:)));
    diffForG = (max(G(:)) - min(G(:)));
    diffForB = (max(B(:)) - min(B(:)));

    %90<Y<180, 90<Cr<130, 80<Cb<150 from "An Efficient Face Detection in Color Images Using
    %Eye Mouth Triangular Approach"
    skinMask = (R > 100) & (G > 50) & (B > 50) & (R > G) & (R > B) & ...
            (95 < Cb) & (Cb < 172) & (Y < 180) & ...
            (abs(R - G) > 15) & (diffForR > 135) & (diffForG > 135) & (diffForB > 135) & ...
            (100 < Cr) & (Cr < 150) & (Cb > 80) & ...
            (Cr <= (1.5862 * Cb + 20)) & (Cr >= (0.3448 * Cb + 76.2069)) & ...
            (Cr <= (-1.15 * Cb + 301.75));

    % % For debugging! Check if there are any ones (1 = skin) in the skinMask
    % if any(skinMask(:))
    %     disp('At least one pixel classified as skin (white) in the skin mask.');
    % else
    %     disp('No pixels classified as skin in the skin mask.');
    % end

    se = strel('disk', 9); 
    se2 = strel('disk', 2);
    skinMask = imdilate(skinMask, se);
 
    skinMask = imdilate(skinMask, se);
    skinMask = imerode(skinMask, se);
    skinMask = imfill(skinMask, 'holes');
    skinMask = imdilate(skinMask, se2);
    skinMask = imerode(skinMask, se2);
    skinMask = imfill(skinMask, 'holes');
    
end