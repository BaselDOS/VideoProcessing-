%% applying on webcam
cam=webcam('HP TrueVision HD');
frame=snapshot(cam);
frameSize=size(frame);
videoPlayer=vision.VideoPlayer('position',[100 100 [frameSize(2),frameSize(1)]]);
runChecker=true;
while(runChecker)
    img=snapshot(cam);
    [croppedImage,bboxPoints]=myFaceDetect(img);
    bboPolygon=reshape(bboxPoints',1,[]);
    frame=insertShape(img,'Polygon',bboxPolygon,'LineWidth',4);
    step(videoPlayer,frame);
    runChecker=isopen(videoPlayer);
end
clear cam;
release(videoPlayer);