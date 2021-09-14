%% webcam face detector with box updated version

faceDetector=vision.CascadeObjectDetector();
pointTracker=vision.PointTracker('MaxBidirectionalError',1);

if (exist('cam')==0)
    cam=webcam();
end

videoFrame=snapshot(cam);
frameSize=size(videoFrame);

videoPlayer=vision.VideoPlayer('Position',[100 100 [frameSize(2),frameSize(1)+10]]);

runChecker=true;
pointsNumber=0;

while(runChecker)
    videoFrame=snapshot(cam);
    videoFrameGray=rgb2gray(videoFrame);
    
    if(pointsNumber<10)
        bbox=faceDetector.step(videoFrameGray);
        if(~isempty(bbox))
            points=detectMinEigenFeatures(videoFrameGray,'ROI',bbox(1,:));
            xyPoints=points.Location;
            pointsNumber=size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker,xyPoints,videoFrameGray);
            
            oldPoints=xyPoints;
            
            bboxPoints=bbox2points(bbox(1,:));
            
            bboxPolygon=reshape(bboxPoints',1,[]);
            videoFrame=insertShape(videoFrame,'Polygon',bboxPolygon,'LineWidth',3);
            videoFrame=insertMarker(videoFrame,xyPoints,'+','Color','White');
        end
        
    else
      [xyPoints,isFound]=step(pointTracker,videoFrameGray);
      visiblePoints=xyPoints(isFound,:);
      oldInliers=oldPoints(isFound,:);
      pointsNumber=size(visiblePoints,1);
      
      if(pointsNumber>=10)
          [xform,oldInliers,visiblePoints]=estimateGeometricTransform(...
              oldInliers,visiblePoints,'Similarity','MaxDistance',4);
          bboxPoints=transformPointsForward(xform,bboxPoints);
          bboxPolygon=reshape(bboxPoints',1,[]);
          videoFrame=insertShape(videoFrame,'Polygon',bboxPolygon,'LineWidth',3);
          videoFrame=insertMarker(videoFrame,visiblePoints,'+','Color','White');
          oldPoints=visiblePoints;
          setPoints(pointTracker,oldPoints);
      end
    end
    step(videoPlayer,videoFrame);
    runChecker=isOpen(videoPlayer);
end
clear cam;
release(videoPlayer);
release(pointTracker);
release(faceDetector);

            





























