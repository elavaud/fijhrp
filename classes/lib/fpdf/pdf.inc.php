<?php

import('classes.lib.fpdf.fpdf');

class PDF extends FPDF {
	function Header()
	{
		$title = $this->title;
		$this->SetFont('Times','B',15);
		// Calculate width of title and position
		$w = $this->GetStringWidth($title)+6;
		$this->SetX((210-$w)/2);
		// Title
		$this->Cell($w,9,$title,0,1,'C');
		// Line break
		$this->Ln(10);
	}

	function Footer()
	{
		// Position at 1.5 cm from bottom
		$this->SetY(-15);
		// Arial italic 8
		$this->SetFont('Times','I',8);
		// Text color in gray
		$this->SetTextColor(128);
		// Page number
		$this->Cell(0,10,'Page '.$this->PageNo(),0,0,'C');
	}

	function ChapterTitle($label, $style = 'B')
	{
		$this->SetFont('Times',$style,16);
		$this->MultiCell(0,6,$label,0,'C');
		$this->Ln();
	}

	function ChapterItemKeyVal($key, $val, $style = 'B')
	{
		$this->SetFont('Times', $style,12);
		$this->Cell(0,6,$key,0,1,'L',false);
		$this->SetFont('Times','',12); 
		$this->MultiCell(0,5,$val);
		// Line break
		$this->Ln();
	}
	
	function ChapterItemKey($key, $style = 'B')
	{
		$this->SetFont('Times', $style,12);
		$this->Cell(0,6,$key,0,1,'L',false);
		$this->SetFont('Times','',12); 		
		// Line break
		$this->Ln();
	}
	
	function ChapterItemVal($val, $style = '')
	{
		$this->SetFont('Times',$style,12); 
		$this->MultiCell(0,5,$val);
		// Line break
		$this->Ln();
	}

}

?>
